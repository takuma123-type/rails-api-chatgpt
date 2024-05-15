class Api::ChatGptController < Api::BaseController
  before_action :validate_params, only: :chat

  def chat
    usecase = Api::ChatGptUsecase.new(
      input: Api::ChatGptUsecase::Input.new(
        prompt: params[:prompt]
      )
    )
    @output = usecase.fetch
    render json: @output
  end

  private

  def validate_params
    render json: { error: 'prompt is required' }, status: :bad_request unless params[:prompt].present?
  end
end
