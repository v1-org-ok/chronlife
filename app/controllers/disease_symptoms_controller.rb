class DiseaseSymptomsController < BaseController
  layout "dashboard"

  before_action :set_disease
  before_action :set_disease_symptom, only: %i[show edit update destroy]
  before_action :set_symptom_name, only: %i[show edit update destroy]
  before_action :load_predefined_symptoms, only: %i[new edit update create]

  before_action :set_breadcrumbs
  before_action :set_breadcrumbs_new, only: %i[new]
  before_action :set_breadcrumbs_show, only: %i[show]
  before_action :set_breadcrumbs_edit, only: %i[edit]

  def index
    @disease_symptoms = @disease.symptoms.includes(:predefined_symptom)

    @predefined_symptoms = @disease_symptoms.to_a.select { |d| d.predefined_symptom_id.present? }
    @custom_symptoms = @disease_symptoms.to_a.select { |d| d.predefined_symptom_id.blank? }
  end

  def show
    @disease_symptom_updates = @disease_symptom.updates.order(update_date: :desc)
  end

  def new
    @disease_symptom = DiseaseSymptom.new
  end

  def edit; end

  def create
    @disease_symptom = @disease.symptoms.new(disease_symptom_params)

    respond_to do |format|
      if @disease_symptom.save
        format.html do
          redirect_to disease_disease_symptoms_path,
                      notice: "Disease symptom was successfully created."
        end
        format.json { render :show, status: :created, location: @disease_symptom }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @disease_symptom.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @disease_symptom.update(disease_symptom_params)
        format.html do
          redirect_to @disease_symptom,
                      notice: "Disease symptom was successfully updated."
        end
        format.json { render :show, status: :ok, location: @disease_symptom }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @disease_symptom.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @disease_symptom.destroy

    respond_to do |format|
      format.html do
        redirect_to disease_disease_symptoms_path, notice: "Disease symptom was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

  def set_disease
    @disease = current_user.account.diseases.find(params[:disease_id])
  end

  def set_disease_symptom
    @disease_symptom = @disease.symptoms.find(params[:id])
  end

  def set_symptom_name
    @symptom_name =
      if @disease_symptom.predefined_symptom_id.present?
        @disease_symptom.predefined_symptom.name
      else
        @disease_symptom.name
      end
  end

  def disease_symptom_params
    params.require(:disease_symptom).permit(:name, :description, :first_noticed_at, :disease_id,
                                            :predefined_symptom_id)
  end

  def set_breadcrumbs
    add_breadcrumb("home", authenticated_root_path)
    add_breadcrumb("choroby", diseases_path)
    add_breadcrumb(@disease.predefined_disease.name, @disease)
    add_breadcrumb("objawy", disease_disease_symptoms_path)
  end

  def set_breadcrumbs_new
    add_breadcrumb("dodaj objaw", new_disease_disease_symptom_path)
  end

  def set_breadcrumbs_show
    add_breadcrumb(@symptom_name, [@disease, @disease_symptom])
  end

  def set_breadcrumbs_edit
    add_breadcrumb(@symptom_name, [@disease, @disease_symptom])
    add_breadcrumb("edytuj objaw", edit_disease_disease_symptom_path(@disease, @disease_symptom))
  end

  def load_predefined_symptoms
    @predefined_symptoms = @disease.predefined_disease.predefined_symptoms.map do |d|
      [d.name, d.id]
    end
  end
end
