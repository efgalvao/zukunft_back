module Account
  class AccountReportsController < ApplicationController
    before_action :authenticate_user!

    def account_reports
      @account_reports = FetchAccountReports.account_reports(account_report_params)
      render json: @account_reports, status: :ok
    end

    def current_account_report
      @account_report = FetchAccountReports.current_account_report(params[:account_id])
      render json: @account_report, status: :ok
    end

    def account_report
      @account_report = FetchAccountReports.account_report(account_report_params)
    end

    private

    def account_report_params
      params.permit(:account_id, :start_date, :end_date)
    end
  end
end
