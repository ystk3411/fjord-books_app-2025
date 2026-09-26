# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @mentions = @report.mentioned_reports.order(id: :desc)
  end

  def new
    @report = Report.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    begin
      ActiveRecord::Base.transaction do
        @report.save!
        ids = extract_local_urls(@report.content)
        add_mentioning_reports(@report, ids)
      end

      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
    end
  end

  def update
    ActiveRecord::Base.transaction do
      ids_all_new = extract_local_urls(params[:report][:content])
      @report.update!(report_params)
      add_mentioning_reports(@report, ids_all_new)
    end

    redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  def destroy
    @report.destroy!

    redirect_to reports_path, status: :see_other, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.expect(report: %i[user_id title content])
  end

  def extract_local_urls(text)
    local_url_regex = %r{http://127\.0\.0\.1:3000[\w?=&./~:-]*?/(\d+)}
    text.scan(local_url_regex).flatten.map(&:to_i).uniq
  end

  def add_mentioning_reports(report, ids)
    report.mentioning_report_ids = ids.uniq
  end
end
