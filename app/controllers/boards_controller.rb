class BoardsController < ApplicationController
  before_action :require_login

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(board_params(:topic, :created_by))
    @board.messages.build(:content => params[:message][:content], :user_id => current_user.id) unless params[:message][:content].empty?
    if @board.save
      redirect_to board_path(@board)
    else
      render :new
    end
  end

  def index
    @boards = Board.all
  end

  def show
    set_board
    @message = Message.new
  end

  def edit
    set_board
    check_user
  end

  def update
    set_board
    check_user
    @board.update(board_params(:topic))
    redirect_to board_path(@board)
  end

  def delete
    set_board
    check_user
  end

  private

  def set_board
    @board = Board.find(params[:id])
  end

  def board_params(*args)
    params.require(:board).permit(*args)
  end

  def check_user
    if @board.creator != current_user
      flash[:alert] = "You are not authorized to edit or delete this board"
      redirect_to board_path(@board)
    end
  end

end
