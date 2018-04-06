# frozen_string_literal: true

class Invoice
  class Update < Trailblazer::Operation
    class Present < Trailblazer::Operation
      step :model!
      failure :order_not_has_invoice!
      step Policy::Pundit(InvoicesPolicy, :can_work_with_invoice?)
      step self::Contract::Build(constant: Invoice::Contract::Create)

      def model!(options, params:, **)
        options[:model] = Invoice[order_id: params[:order_id]]
      end

      def order_not_has_invoice!(options, params:, **)
        options[:errors] = {
          message: "Order with id: #{params[:order_id]} not has invoice.",
          status: 404
        }
      end
    end

    step Nested(Present)
    step self::Contract::Validate(key: :invoice)
    step Wrap(SequelTransaction) {
      step self::Contract::Persist()
      step :add_additional_amount_to_payed_amount
      step :take_away_additional_amount_from_indebtedness
      step :update_invoice_status
      success :send_email_with_invoice_to_user
    }

    def add_additional_amount_to_payed_amount(_options, model:, params:, **)
      model.payed_amount +=
        BigDecimal(params['invoice']['additional_amount'])
    end

    def take_away_additional_amount_from_indebtedness(_options, model:, params:, **)
      model.indebtedness -=
        BigDecimal(params['invoice']['additional_amount'])
    end

    def update_invoice_status(_options, model:, **)
      if model.indebtedness.zero?
        model.update(invoice_status: 'Paid')
      elsif model.payed_amount.zero? && model.indebtedness != 0
        model.update(invoice_status: 'Unpaid')
      else
        model.update(invoice_status: 'Partially paid')
      end
    end

    def send_email_with_invoice_to_user(_options, model:, **)
      if model.order.user_id
        user = User[model.order.user_id]
        UserMailer.invoice_report_mail(user, model)
      end
    end
  end
end
