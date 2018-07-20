# frozen_string_literal: true

class Accounts::SubscriptionPaymentsController < ApplicationController
  before_action :authenticate_user!
  layout false

  def preview
    new_plan   = SubscriptionPlan.find(params[:plan])
    calculator = Subscriptions::Calculator.new(new_plan, current_user)
    respond_to do |format|
      format.js do
        render('accounts/subscription_payments/preview', locals: { calculator: calculator })
      end
    end
  end

  def new
    new_plan = SubscriptionPlan.find(params[:plan])
    builder  = Subscriptions::Builder.new(new_plan, current_user)
    builder.payment_manager.call(builder.calculator, builder.messager) do |adapter|
      session.delete(:subscription_plan_id)
      return redirect_to(adapter.approval_url)
    end

    flash[:error] = I18n.t('flash.errors.payment')
    redirect_to accounts_subscriptions_path
  end

  def free
    new_plan = SubscriptionPlan.find(params[:plan])
    builder  = Subscriptions::Builder.new(new_plan, current_user)
    payment_manager = builder.payment_manager(Payment::Adapters::Dummy.new)
    payment_manager.call(builder.calculator, builder.messager) do |adapter|
      Subscriptions::Manager.new(adapter.payment, current_user).call do |_user, was_user|
        flash[:success] = I18n.t('flash.success.payment')
        return redirect_to(finish_redirect(was_user))
      end
    end
    redirect_to(subscriptions_accounts_pataccounts_subscriptions_pathh, error: I18n.t('flash.errors.payment'))
  end

  def done
    adapter = Payment::Adapters::Paypal.new
    adapter.finish(params[:payment], params[:paymentId],
                   params[:PayerID]) do |payment|
      service = Subscriptions::Manager.new(payment, current_user)
      service.call do |_user, was_user|
        flash[:success] = I18n.t('flash.success.payment')
        return redirect_to(finish_redirect(was_user))
      end
    end

    redirect_to(accounts_subscriptions_path, error: I18n.t('flash.errors.payment'))
  end

  def cancel
    Payment.find(params[:payment]).cancel!
    redirect_to(accounts_subscriptions_path,
                error: I18n.t('flash.error.payment_cancel'))
  end

  private

  def finish_redirect(was_user)
    was_user ? edit_accounts_supplier_information_path : accounts_root_path
  end
end
