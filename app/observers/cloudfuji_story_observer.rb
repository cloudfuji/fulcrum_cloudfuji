class CloudfujiStoryObserver < ActiveRecord::Observer
  observe :story

  def after_create(story)
    return unless ::Cloudfuji::Platform.on_cloudfuji?

    event = {
      :category => :project_task,
      :name     => :created,
      :data     => event_data_for_story(story)
    }

    puts "Publishing Cloudfuji Event: #{event.inspect}"
    ::Cloudfuji::Event.publish(event)
  end

  def after_update(story)
    return unless ::Cloudfuji::Platform.on_cloudfuji?

    event = {
      :category => :project_task,
      :name     => :updated,
      :data     => event_data_for_story(story)
    }

    puts "Publishing Cloudfuji Event: #{event.inspect}"
    ::Cloudfuji::Event.publish(event)
  end


  private

  def event_data_for_story(story)
    project_url = Rails.application.routes.url_helpers.project_url(story.project, :host => ENV['CLOUDFUJI_DOMAIN'])
    {
      :ido_id          => story.ido_id,
      :title           => story.title,
      :description     => story.description,
      :estimate        => story.estimate,
      :task_type       => story.story_type,
      :state           => story.state,
      :accepted_at     => story.accepted_at,
      :owned_by_id     => story.owned_by && story.owned_by.ido_id,
      :requested_by_id => story.requested_by && story.requested_by.ido_id,
      :project_id      => story.project.ido_id,
      :labels          => story.labels,
      :url             => project_url
    }
  end
end

