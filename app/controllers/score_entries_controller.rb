class ScoreEntriesController < ApplicationController
  def create
    entry = current_user.score_entries.build(score_entry_params)
    if entry.save
      redirect_to root_path, notice: "Score check-in logged."
    else
      redirect_to root_path, alert: entry.errors.full_messages.to_sentence
    end
  end

  def destroy
    current_user.score_entries.find(params[:id]).destroy
    redirect_to root_path, notice: "Check-in removed.", status: :see_other
  end

  private

  def score_entry_params
    params.require(:score_entry).permit(:score, :recorded_on)
  end
end
