require 'rails_helper'

RSpec.describe 'Account::AccountReportsController', type: :request do
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }

  describe 'GET #account_reports' do
    before do
      create_list(:account_report, 3, date: Date.parse('2023-02-02'), account: account)
      create(:account_report, date: Date.parse('2024-01-02'), account: account)
    end

    let(:savings_account) { create(:account, user: user) }

    it 'returns a list of all account reports in the requested period', :aggregate_failures do
      sign_in user
      get "/api/v1/accounts/#{account.id}/account_reports",
          params: { account_id: account.id, start_date: '2023-01-01', end_date: '2023-12-31' }

      expect(response).to have_http_status(:success)

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)
      expect(parsed_response.count).to eq(3)
    end
  end

  describe 'GET #current_account_report' do
    let(:user) { create(:user) }

    let!(:current_month_report) { create(:account_report, date: Date.current, account: account) }
    let!(:old_report) { create(:account_report, date: Date.current - 1.month, account: account) }

    it 'returns account report from the current month', :aggregate_failures do
      sign_in user
      get "/api/v1/accounts/#{account.id}/current_account_report"

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['id']).to eq(current_month_report.id.to_s)
      expect(parsed_response['id']).not_to eq(old_report.id.to_s)
    end
  end

  describe 'GET #account_report' do
    let!(:old_report) { create(:account_report, date: Date.parse('2023-01-09'), account: account) }
    let!(:report) { create(:account_report, date: Date.parse('2023-09-22'), account: account) }

    let(:savings_account) { create(:account, user: user) }

    it 'return account report in the requested period', :aggregate_failures do
      sign_in user
      get "/api/v1/accounts/#{account.id}/account_report", params: { account_id: account.id, start_date: '2023-09-01' }

      expect(response).to have_http_status(:success)

      expect(response).to be_successful

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['id']).to eq(report.id.to_s)
      expect(parsed_response['id']).not_to eq(old_report.id.to_s)
    end
  end
end
