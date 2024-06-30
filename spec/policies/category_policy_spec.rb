require "rails_helper"
require "auth_context"

RSpec.describe CategoryPolicy, type: :policy do
  include_context "auth"

  subject { described_class }

  permissions :show?, :update?, :destroy? do
    it "denies access if record is not associated with user" do
      expect(subject).not_to permit(logged_user, create(:category))
    end
  end
end
