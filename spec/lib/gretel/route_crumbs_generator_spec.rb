require 'rails_helper'

describe Gretel::RouteCrumbsGenerator do
  before { Gretel.reset! }

  it 'generate breadcrumbs config from routes.' do
    expect(Gretel::RouteCrumbsGenerator.generate).to eq <<~RUBY
      crumb :root do
        link t('breadcrumbs.root'), root_path
      end

      crumb :about do
        link t('breadcrumbs.about'), about_path
        parent :root
      end

      crumb :contact do
        link t('breadcrumbs.contact'), contact_path
        parent :about
      end

      crumb :contact_form do
        link t('breadcrumbs.contact_form'), contact_form_path
        parent :contact
      end

      crumb :new_project_issue_assignee do |project, issue|
        link t('breadcrumbs.new_project_issue_assignee'), new_project_issue_assignee_path(project, issue)
        parent :project_issue_assignee, project, issue
      end

      crumb :edit_project_issue_assignee do |project, issue|
        link t('breadcrumbs.edit_project_issue_assignee'), edit_project_issue_assignee_path(project, issue)
        parent :project_issue_assignee, project, issue
      end

      crumb :project_issue_assignee do |project, issue|
        link t('breadcrumbs.project_issue_assignee'), project_issue_assignee_path(project, issue)
        parent :project_issue, project, issue
      end

      crumb :project_issue_comments do |project, issue|
        link t('breadcrumbs.project_issue_comments'), project_issue_comments_path(project, issue)
        parent :project_issue, project, issue
      end

      crumb :new_project_issue_comment do |project, issue|
        link t('breadcrumbs.new_project_issue_comment'), new_project_issue_comment_path(project, issue)
        parent :project_issue_comments, project, issue
      end

      crumb :edit_project_issue_comment do |project, issue, comment|
        link comment.name, edit_project_issue_comment_path(project, issue, comment)
        parent :project_issue_comment, project, issue, comment
      end

      crumb :project_issue_comment do |project, issue, comment|
        link comment.name, project_issue_comment_path(project, issue, comment)
        parent :project_issue_comments, project, issue
      end

      crumb :project_issues do |project|
        link t('breadcrumbs.project_issues'), project_issues_path(project)
        parent :project, project
      end

      crumb :new_project_issue do |project|
        link t('breadcrumbs.new_project_issue'), new_project_issue_path(project)
        parent :project_issues, project
      end

      crumb :edit_project_issue do |project, issue|
        link issue.name, edit_project_issue_path(project, issue)
        parent :project_issue, project, issue
      end

      crumb :project_issue do |project, issue|
        link issue.name, project_issue_path(project, issue)
        parent :project_issues, project
      end

      crumb :projects do
        link t('breadcrumbs.projects'), projects_path
        parent :root
      end

      crumb :new_project do
        link t('breadcrumbs.new_project'), new_project_path
        parent :projects
      end

      crumb :edit_project do |project|
        link project.name, edit_project_path(project)
        parent :project, project
      end

      crumb :project do |project|
        link project.name, project_path(project)
        parent :projects
      end

      crumb :admin_root do
        link t('breadcrumbs.admin_root'), admin_root_path
        parent :root
      end

      crumb :admin_projects do
        link t('breadcrumbs.admin_projects'), admin_projects_path
        parent :admin_root
      end

      crumb :new_admin_project do
        link t('breadcrumbs.new_admin_project'), new_admin_project_path
        parent :admin_projects
      end

      crumb :edit_admin_project do |project|
        link project.name, edit_admin_project_path(project)
        parent :admin_project, project
      end

      crumb :admin_project do |project|
        link project.name, admin_project_path(project)
        parent :admin_projects
      end

      crumb :edit_mypage_setting do
        link t('breadcrumbs.edit_mypage_setting'), edit_mypage_setting_path
        parent :mypage_setting
      end

      crumb :mypage_setting do
        link t('breadcrumbs.mypage_setting'), mypage_setting_path
        parent :root
      end
    RUBY
  end
end
