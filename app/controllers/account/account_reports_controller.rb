module Account
  class AccountReportsController < ApplicationController
    before_action :authenticate_user!

    def account_reports
      @account_reports = FetchAccountReports.account_reports(account_report_params)

      serialized_account_reports = AccountReportSerializer.new(@account_reports).serializable_hash[:data]

      render json: serialized_account_reports, status: :ok
    end

    def current_account_report
      @account_report = FetchAccountReports.current_account_report(params[:account_id])

      serialized_account_report = AccountReportSerializer.new(@account_report).serializable_hash[:data]

      render json: serialized_account_report, status: :ok
    end

    def account_report
      @account_report = FetchAccountReports.account_report(account_report_params)

      serialized_account_report = AccountReportSerializer.new(@account_report).serializable_hash[:data]

      render json: serialized_account_report, status: :ok
    end

    private

    def account_report_params
      params.permit(:account_id, :start_date, :end_date)
    end
  end
end
