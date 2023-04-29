module Account
  class FetchAccountReports < ApplicationService
    def self.current_account_report(account_id)
      start_date = Time.zone.today.beginning_of_month
      end_date = Time.zone.today.end_of_month
      AccountReport.find_by(account_id: account_id, date: start_date..end_date)
    end

    def self.account_reports(params)
      start_date = params[:start_date].to_date.beginning_of_month
      end_date = params[:end_date].to_date.end_of_month
      AccountReport.where(account_id: params[:account_id], date: start_date..end_date)
    end

    def self.account_report(params)
      start_date = params[:start_date].to_date.beginning_of_month
      end_date = params[:start_date].to_date.end_of_month
      AccountReport.find_by(account_id: params[:account_id], date: start_date..end_date)
    end

    def call
      if @end_date.nil?
        self.class.current_account_report(@account_id)
      else
        self.class.account_reports(@account_id, @start_date, @end_date)
      end
    end
  end
end
