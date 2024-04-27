# frozen_string_literal: true

module Api
  class CastMembersController < ApplicationController
    def index
      cast_member_repository = Infra::Repository::ActiveRecordCastMemberRepository.new
      use_case = Application::UseCase::ListCastMember.new(cast_member_repository:)
      input = Application::DTO::ListCastMemberInput
      output = use_case.execute(input)

      render json: {
        data: output.data
      }, status: :ok
    end

    def create
      cast_member_repository = Infra::Repository::ActiveRecordCastMemberRepository.new
      use_case = Application::UseCase::CreateCastMember.new(cast_member_repository:)
      input = Application::DTO::CreateCastMemberInput.new(create_params)
      output = use_case.execute(input)

      render json: {
        data: output
      }, status: :created
    rescue Exceptions::InvalidCastMemberData => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def destroy
      cast_member_repository = Infra::Repository::ActiveRecordCastMemberRepository.new
      use_case = Application::UseCase::DeleteCastMember.new(cast_member_repository:)
      input = Application::DTO::DeleteCastMemberInput.new(id: params[:id])
      use_case.execute(input)

      head :no_content
    rescue Exceptions::CastMemberNotFound => e
      render json: { error: e.message }, status: :not_found
    end

    def update
      cast_member_repository = Infra::Repository::ActiveRecordCastMemberRepository.new
      use_case = Application::UseCase::UpdateCastMember.new(cast_member_repository:)
      input = Application::DTO::UpdateCastMemberInput.new(update_params)
      use_case.execute(input)

      head :no_content
    rescue Exceptions::InvalidCastMemberData => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue Exceptions::CastMemberNotFound => e
      render json: { error: e.message }, status: :not_found
    end

    private

    def update_params
      params.permit(:id, :name, :type)
            .to_h
            .symbolize_keys
    end

    def create_params
      params.permit(:name, :type).to_h.symbolize_keys
    end
  end
end
