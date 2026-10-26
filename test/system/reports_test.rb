# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:one)
    visit root_path
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'Password!'
    click_button 'ログイン'
    assert_text 'ログインしました。'
    visit reports_path
    assert_selector 'h1', text: '日報の一覧'
  end

  test '#create report' do
    click_on '日報の新規作成'
    fill_in 'タイトル', with: 'テストの日報'
    fill_in '内容', with: 'テスト用日報です。'
    click_button '登録する'
    assert_text '日報が作成されました。'
    assert_text 'テスト用日報です。'
  end

  test '#edit report' do
    visit report_path(@report)
    click_on 'この日報を編集'
    fill_in 'タイトル', with: '日報を更新'
    fill_in '内容', with: 'テスト用日報を更新。'
    click_button '更新する'
    assert_text '日報が更新されました。'
    assert_text 'テスト用日報を更新。'
  end

  test '#destroy report' do
    visit report_path(@report)
    click_button 'この日報を削除'
    assert_text '日報が削除されました。'
    assert_raise(ActiveRecord::RecordNotFound) do
      Report.find(@report.id)
    end
  end
end
