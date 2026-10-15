# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?' do
    user = users(:alice)
    report = user.reports.new(content: 'テスト用日報')
    assert report.editable?(user)
  end

  test '#created_on' do
    target_time = Time.zone.local(2026, 10, 9)
    report = Report.new(created_at: target_time)
    expected_date = Date.new(2026, 10, 9)
    assert_equal expected_date, report.created_on
  end

  MENTION_REGEXP = %r{http://localhost:3000/reports/(\d+)}
  test '#save_mentions' do
    user = users(:alice)
    report_mentioned = user.reports.create!(title: '言及先日報', content: '言及されている日報')
    report_mentioning = user.reports.create!(title: '言及元日報', content: "http://localhost:3000/reports/#{report_mentioned.id}")
    assert_equal report_mentioned, report_mentioning.mentioning_reports[0]
  end
end
