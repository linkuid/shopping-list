# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :set_group, only: %i[edit update destroy status]

  def index
    @groups = current_user.groups.order(:position).all
  end

  def new
    @group = current_user.groups.new(position: (current_user.groups.maximum(:position) || 0) + 1)
  end

  def edit; end

  def create
    @group = current_user.groups.new(group_params)

    if @group.save
      GroupOrderService.new.call(@group)
      redirect_to groups_path, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      GroupOrderService.new.call(@group)
      redirect_to groups_path, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, notice: 'Group was successfully destroyed.'
  end

  def status
    @group.update(active: params[:active])
    redirect_back(fallback_location: root_path)
  end

  private

  def set_group
    @group = current_user.groups.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :position)
  end
end
