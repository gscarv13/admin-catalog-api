# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::UseCase::UploadVideo do
  it 'should upload video and update video' do
    video = Domain::Video.new(
      title: 'Movie',
      description: '',
      launch_year: 2023,
      duration: BigDecimal('120'),
      published: true,
      rating: 'l',
      categories: [],
      genres: [],
      cast_members: []
    )

    video_repository = instance_double(Domain::VideoRepository, get_by_id: video, update: nil)
    storage = instance_double(Infra::Storage::AbstractStorage, store: true)

    use_case = Application::UseCase::UploadVideo.new(video_repository:, storage:)

    input = Application::DTO::UploadVideoInput.new(
      video_id: video.id,
      file_name: 'video.mp4',
      content_type: 'video/mp4',
      content: 'file_content'
    )

    use_case.execute(input)

    expect(storage).to(have_received(:store).with(
                         file_path: "/videos/#{input.video_id}/#{input.file_name}",
                         content: input.content,
                         content_type: input.content_type
                       ))

    expect(video_repository).to(have_received(:update).with(video))

    expected_audio_video_medium = Domain::ValueObjects::AudioVideoMedium.new(
      name: input.file_name,
      raw_location: "/videos/#{input.video_id}/#{input.file_name}",
      encoded_location: '',
      status: Domain::ValueObjects::AudioVideoMedium::MEDIA_STATUS[:pending]
    )

    expect(video.video == expected_audio_video_medium).to(eq(true))
  end
end
