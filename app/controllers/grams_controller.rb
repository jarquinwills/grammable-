class GramsController < ApplicationController

  def index
  
  end

  def new 
    @gram = Gram.new
  end

  def create 
    Gram.create(grams_params)
    redirect_to root_path
  end

  private

  def grams_params
    params.require(:gram).permit(:message)
  end

end
