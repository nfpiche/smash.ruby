require './spec/spec_helper'

describe SmashRuby::Errors::ErrorHandler do
  it 'returns a NotFoundError when status is 404' do
    error = SmashRuby::Errors::ErrorHandler.build_error(SmashRuby::Tournament, 'request', 404)
    expect(error.is_a?(SmashRuby::Errors::NotFoundError)).to be true
  end

  it 'returns an UnknownError otherwise' do
    error = SmashRuby::Errors::ErrorHandler.build_error(SmashRuby::Tournament, 'request', 500)
    expect(error.is_a?(SmashRuby::Errors::UnknownError)).to be true
  end
end
