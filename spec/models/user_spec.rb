# require "rails_helper"


# RSpec.describe User do
#   context "バリデーション" do
#     it "emailの正規表現が正しいこと" do
#       user = build(:user, email: "info@to-ko-s.com")
#       expect(user).to be_valid
#     end

#     it "emailの正規表現が誤っていること" do
#       user = build(:user)
#       user.email = "info@to-ko-s"
#       expect(user).to be_valid
#     end

#     it "emailの正規表現が誤っていること" do
#       user = build(:user)
#       user.email = "info.to-ko-s.com"
#       expect(user).to be_invalid
#     end
#   end
# end