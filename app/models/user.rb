# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#
class User < ApplicationRecord
    validates :user_name, presence: true
    validates :password_digest, presence: true
    validates :session_token, presence: true, uniqueness: true

    after_initialize do |user|
        user.session_token ||= User.generate_session_token
    end


    
    has_many :cat_rental_requests,
        foreign_key: :user_id,
        class_name: :CatRentalRequest

    has_many :cats,
        foreign_key: :user_id,
        class_name: :Cat
    
    def self.generate_session_token
        SecureRandom.urlsafe_base64(16)
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(user_name: username)
        return user if user && user.is_password?(password)
        nil
    end

    def reset_session_token!
        self.session_token = User.generate_session_token
        self.save!
        self.session_token
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        digest_instance = BCrypt::Password.new(self.password_digest)
        digest_instance.is_password?(password)
    end


    
end
