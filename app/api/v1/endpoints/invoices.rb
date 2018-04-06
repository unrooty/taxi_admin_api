# frozen_string_literal: true

module V1
  module Endpoints
    class Invoices < Grape::API
      resource :orders do
        desc '',
             entity: V1::Entities::Invoice,
             nickname: 'createNewInvoiceOfOrder',
             detail: 'Creates invoice of chosen order.
                      Total price and indebtedness counts automatically',
             summary: 'Create invoice.',
             http_codes: DocHelper.create_codes('invoice')

        params do
          requires :invoice, type: Hash do
            requires :distance, type: BigDecimal,
                                desc: 'Distance of trip.',
                                allow_blank: false
            requires :payed_amount, type: BigDecimal,
                                    desc: 'Money that client payed.',
                                    allow_blank: false
          end
        end

        post ':order_id/invoice' do
          result = Invoice::Create.call(params: params,
                                               current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::Invoice
          end

          handle_invalid(result) do
            error!(@contract.errors, 422)
          end
        end

        desc '',
             entity: V1::Entities::Invoice,
             nickname: 'getInvoiceOfOrder',
             detail: 'Returns information about invoice of chosen order.',
             summary: 'Get invoice.',
             http_codes: DocHelper.show_codes('invoice')

        get ':order_id/invoice' do
          result = Invoice::Update::Present.call(params: params,
                                                        current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::Invoice
          end

          handle_invalid(result) do
            error!(@contract.errors, 422)
          end
        end

        desc '',
             entity: V1::Entities::Invoice,
             nickname: 'updateInvoiceOfOrder',
             detail: 'Updates invoice of chosen order.
                    Indebtedness counts automatically',
             summary: 'Update invoice.',
             http_codes: DocHelper.create_codes('invoice')

        params do
          requires :invoice, type: Hash do
            requires :additional_amount, type: BigDecimal,
                                         desc: 'Additional amount that client payed.'
          end
        end

        patch ':order_id/invoice' do
          result = Invoice::Update.call(params: params,
                                               current_user: current_user)
          handle_successful(result) do
            present @model, with: V1::Entities::Invoice
          end

          handle_invalid(result) do
            error!(@contract.error!, 422)
          end
        end
      end
    end
  end
end
