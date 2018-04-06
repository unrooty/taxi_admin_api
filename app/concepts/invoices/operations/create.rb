# frozen_string_literal: true

class Invoice
  class Create < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step Model(Invoice, :new)
      step Policy::Pundit(InvoicesPolicy, :can_work_with_invoice?)
      step self::Contract::Build(constant: Invoice::Contract::Create)
    end

    step Nested(Present)
    step self::Contract::Validate(key: :invoice)
    step Wrap(SequelTransaction) {
      step :find_order
      failure :order_not_found!, fail_fast: true
      step :order_not_has_invoice?
      failure :order_already_has_invoice!, fail_fast: true
      step :find_car
      failure :car_not_assigned
      step :set_order_id_to_invoice
      step self::Contract::Persist()
      step :count_total_price
      step :count_indebtedness
      step :update_order_status_to_completed
      step :update_car_status_to_free
      step :set_invoice_status
      success :send_email_with_invoice_to_user
    }

    private

    def find_order(_options, params:, **)
      @order = Order[params['order_id']]
    end

    def order_not_found!(options, params:, **)
      options[:errors] = {
        message: "Order with id: #{params['order_id']} not found.",
        status: 404
      }
    end

    def order_not_has_invoice?(*)
      !@order.invoice
    end

    def order_already_has_invoice!(options, params:, **)
      options[:errors] = {
        message: "Order with id: #{params['order_id']} already has invoice.",
        status: 422
      }
    end

    def find_car(_options, **)
      @car = @order.car
    end

    def car_not_assigned(options, *)
      options[:errors] = {
        message: 'Car not assigned to order. Please, assign car and try again.',
        status: 422
      }
    end

    def set_order_id_to_invoice(_options, model:, params:, **)
      model.order_id = params['order_id']
    end

    def count_total_price(_options, model:, **)
      tax = @order.tax
      model.update(total_price: BigDecimal(model.distance *
                          tax.cost_per_km +
                          tax.basic_cost))
    end

    def count_indebtedness(_options, model:, **)
      model.update(indebtedness: BigDecimal(model.total_price -
                                 model.payed_amount))
    end

    def update_order_status_to_completed(_options, **)
      @order.update(order_status: 'Completed')
    end

    def update_car_status_to_free(_options, **)
      @car.update(car_status: 'Free')
    end

    def set_invoice_status(_options, model:, **)
      if model.indebtedness.zero?
        model.update(invoice_status: 'Paid')
      elsif model.payed_amount.zero?
        model.update(invoice_status: 'Unpaid')
      else
        model.update(invoice_status: 'Partially paid')
      end
    end

    def send_email_with_invoice_to_user(_options, model:, **)
      if @order.user_id
        user = User[@order.user_id]
        UserMailer.invoice_report_mail(user, model)
      end
    end
  end
end
