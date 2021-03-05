# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :user
  has_many :items, -> { order(:position) }, inverse_of: :group, dependent: :destroy
  has_many :regular_items, -> { regular.order(:position) }, class_name: 'Item', inverse_of: :group

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :position, presence: true
end
