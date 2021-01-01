class SDG::Goals::IconComponent < ApplicationComponent
  attr_reader :goal
  delegate :code, to: :goal

  def initialize(goal)
    @goal = goal
  end

  private

    def image_path
      "sdg/#{folder}/goal_#{code}.png"
    end

    def image_text
      goal.code_and_title
    end

    def folder
      [*I18n.fallbacks[I18n.locale], ""].find do |locale|
        Sprockets::Railtie.build_environment(Rails.application).find_asset("sdg/#{locale}/goal_#{code}")
      end
    end
end
