# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::UseCase::ProcessAudioVideoMedium do
  it 'should raise an error if video does not exist' do
    video_repository = instance_double(Infra::Repository::ActiveRecordVideoRepository, get_by_id: nil)

    use_case = Application::UseCase::ProcessAudioVideoMedium.new(video_repository:)

    input_dto = Application::DTO::ProcessAudioVideoMediumInput.new(
      encoded_location: '',
      video_id: SecureRandom.uuid,
      status: Domain::ValueObjects::AudioVideoMedium::MEDIA_STATUS[:completed],
      medium_type: Domain::ValueObjects::AudioVideoMedium::MEDIA_TYPE[:video]
    )

    expect { use_case.execute(input_dto) }.to(raise_error(Exceptions::VideoNotFound, 'Video not found'))
  end

  it 'should raise an error if there is no video medium associated' do
    video = create(:video)

    video_repository = Infra::Repository::ActiveRecordVideoRepository.new

    use_case = Application::UseCase::ProcessAudioVideoMedium.new(video_repository:)

    input_dto = Application::DTO::ProcessAudioVideoMediumInput.new(
      encoded_location: '',
      video_id: video.id,
      status: Domain::ValueObjects::AudioVideoMedium::MEDIA_STATUS[:completed],
      medium_type: Domain::ValueObjects::AudioVideoMedium::MEDIA_TYPE[:video]
    )

    expect { use_case.execute(input_dto) }.to(
      raise_error(Exceptions::MediumNotFound, 'Video must have medium to be processed')
    )
  end

  it 'should process audio video medium' do
    video = create(:video)
    create(:audio_video_medium, video:)

    video.reload

    video_repository = Infra::Repository::ActiveRecordVideoRepository.new
    use_case = Application::UseCase::ProcessAudioVideoMedium.new(video_repository:)

    input_dto = Application::DTO::ProcessAudioVideoMediumInput.new(
      encoded_location: '',
      video_id: video.id,
      status: Domain::ValueObjects::AudioVideoMedium::MEDIA_STATUS[:completed],
      medium_type: Domain::ValueObjects::AudioVideoMedium::MEDIA_TYPE[:video]
    )

    use_case.execute(input_dto)
  end
end
