class ScoreGoalsController < ApplicationController
  def new
    @score_goal = current_user.build_score_goal(target_date: 6.months.from_now.to_date)
  end

  def create
    @score_goal = current_user.build_score_goal(score_goal_params)
    if @score_goal.save
      redirect_to root_path, notice: "Goal set — the coach will track it."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @score_goal = current_user.score_goal
  end

  def update
    @score_goal = current_user.score_goal
    if @score_goal.update(score_goal_params)
      redirect_to root_path, notice: "Goal updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def score_goal_params
    params.require(:score_goal).permit(:target_score, :target_date)
  end
end
