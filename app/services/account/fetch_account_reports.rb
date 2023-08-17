module Account
  class FetchAccountReports < ApplicationService
    def self.current_account_report(account_id)
      start_date = Time.zone.today.beginning_of_month
      end_date = Time.zone.today.end_of_month
      current_report = AccountReport.find_by(account_id: account_id, date: start_date..end_date)

      return current_report unless current_report.nil?

      AccountReport.create(account_id: account_id, date: Time.zone.now)
    end

    def self.account_reports(params)
      start_date = params.fetch('start_date').to_date.beginning_of_month
      end_date = params.fetch('end_date').to_date.end_of_month
      AccountReport.where(account_id: params[:account_id],
                          date: start_date..end_date).order(date: :asc)
    end

    def self.account_report(params)
      start_date = params[:start_date].to_date.beginning_of_month
      end_date = params[:start_date].to_date.end_of_month
      AccountReport.find_by(account_id: params[:account_id], date: start_date..end_date)
    end
  end
end
