# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable? returns true' do
    user = users(:alice)
    report = user.reports.new(content: 'テスト用日報')
    assert report.editable?(user)
  end

  test '#editable? returns false' do
    user = users(:alice)
    report = user.reports.new(content: 'テスト用日報')
    refute report.editable?(:bob)
  end

  test '#created_on' do
    target_time = Time.zone.local(2026, 10, 9)
    report = Report.new(created_at: target_time)
    expected_date = Date.new(2026, 10, 9)
    assert_equal expected_date, report.created_on
  end

  test '#save_mentions when report create' do
    user = users(:alice)
    report_mentioned = user.reports.create!(title: '言及先日報', content: '言及されている日報')
    report_mentioning = user.reports.create!(title: '言及元日報', content: "http://localhost:3000/reports/#{report_mentioned.id}")
    assert_equal report_mentioned, report_mentioning.mentioning_reports[0]
  end

  test '#save_mentions when report udpate' do
    user = users(:alice)
    report_mentioned_keep = user.reports.create!(title: '保持確認用言及先日報', content: '保持される日報です')
    report_mentioned_add = user.reports.create!(title: '追加確認用言及先日報', content: '追加される日報です')
    report_mentioned_delete = user.reports.create!(title: '削除確認用言及先日報', content: '削除される日報です')
    report_mentioning = user.reports.create!(title: '言及元日報', content: "http://localhost:3000/reports/#{report_mentioned_keep.id}、http://localhost:3000/reports/#{report_mentioned_delete.id}")
    report_mentioning.update(title: '日報を更新', content: "http://localhost:3000/reports/#{report_mentioned_keep.id}、http://localhost:3000/reports/#{report_mentioned_add.id}")
    report_mentioning.reload
    refute_equal report_mentioning.mentioning_reports[1], report_mentioned_delete
    assert_equal report_mentioning.mentioning_reports[0], report_mentioned_keep
    assert_equal report_mentioning.mentioning_reports[1], report_mentioned_add
  end
end
