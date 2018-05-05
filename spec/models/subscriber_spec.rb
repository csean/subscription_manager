require 'rails_helper'

describe Subscriber, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value('jimbob@gmail.com').for(:email) }
    it { is_expected.not_to allow_value('jimbob-at-gmail.com').for(:email) }

    context 'uniqueness' do
      subject { create :subscriber }
      it { is_expected.to validate_uniqueness_of(:email) }
    end
  end
end
