module AuthenticationHelper
  def authenticate_user(user)
    allow(Authentication::JwtToken::DecoderService)
      .to receive(:call)
      .and_return(Dry::Monads::Result::Success.new({"valid_for" => "authentication", "user_id" => user.id}))
  end
end
