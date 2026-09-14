class DisputesController < ApplicationController
  before_action :set_dispute, only: %i[show edit update destroy submit resolve]

  def index
    @disputes = current_user.disputes.order(created_at: :desc)
  end

  def show; end

  def new
    @dispute = current_user.disputes.build
  end

  def create
    @dispute = current_user.disputes.build(dispute_params)
    if @dispute.save
      redirect_to @dispute, notice: "Dispute drafted. Review the details, then submit."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @dispute.update(dispute_params)
      redirect_to @dispute, notice: "Dispute updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @dispute.destroy
    redirect_to disputes_path, notice: "Dispute deleted.", status: :see_other
  end

  def submit
    @dispute.submit!
    redirect_to @dispute, notice: "Dispute submitted to #{@dispute.bureau} with a generated letter."
  rescue ArgumentError => e
    redirect_to @dispute, alert: e.message
  end

  def resolve
    @dispute.resolve!(outcome: params[:outcome], notes: params[:notes])
    redirect_to @dispute, notice: "Dispute #{@dispute.status}."
  rescue ArgumentError => e
    redirect_to @dispute, alert: e.message
  end

  private

  def set_dispute
    @dispute = current_user.disputes.find(params[:id])
  end

  def dispute_params
    params.require(:dispute).permit(:bureau, :item_description, :reason)
  end
end
