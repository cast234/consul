require "rails_helper"

describe "Polymorphic routes" do
  describe "polymorphic_path" do
    it "routes investments" do
      budget = create(:budget)
      investment = create(:budget_investment, budget: budget)

      expect(polymorphic_path(investment)).to eq budget_investment_path(budget, investment)
    end

    it "routes legislation proposals" do
      process = create(:legislation_process)
      proposal = create(:legislation_proposal, process: process)

      expect(polymorphic_path(proposal)).to eq legislation_process_proposal_path(process, proposal)
    end

    it "routes legislation questions" do
      process = create(:legislation_process)
      question = create(:legislation_question, process: process)

      expect(polymorphic_path(question)).to eq legislation_process_question_path(process, question)
    end

    it "routes legislation annotations" do
      process = create(:legislation_process)
      draft_version = create(:legislation_draft_version, process: process)
      annotation = create(:legislation_annotation, draft_version: draft_version)

      expect(polymorphic_path(annotation)).to eq(
        legislation_process_draft_version_annotation_path(process, draft_version, annotation)
      )
    end

    it "routes poll questions" do
      question = create(:poll_question)

      expect(polymorphic_path(question)).to eq question_path(question)
    end

    it "routes topics" do
      community = create(:proposal).community
      topic = create(:topic, community: community)

      expect(polymorphic_path(topic)).to eq community_topic_path(community, topic)
    end
  end

  describe "polymorphic index" do
    include ActionDispatch::Routing::UrlFor

    it "routes debates" do
      debate = create(:debate)

      expect(polymorphic_index(debate)).to eq debates_path
    end

    it "routes proposals" do
      proposal = create(:proposal)

      expect(polymorphic_index(proposal)).to eq proposals_path
    end

    it "routes legislation proposals" do
      process = create(:legislation_process)
      proposal = create(:legislation_proposal, process: process)

      expect(polymorphic_index(proposal)).to eq legislation_process_proposals_path(process)
    end

    it "routes investments" do
      budget = create(:budget)
      investment = create(:budget_investment, budget: budget)

      expect(polymorphic_index(investment)).to eq budget_investments_path(budget)
    end

    it "routes class names" do
      expect(polymorphic_index("Debate")).to eq debates_path
    end

    it "routes new records" do
      expect(polymorphic_index(Proposal.new)).to eq proposals_path
    end

    it "routes nested new records" do
      budget = create(:budget)

      expect(polymorphic_index(Budget::Investment.new(budget: budget))).to eq budget_investments_path(budget)
    end

    it "accepts extra parameters" do
      budget = create(:budget)
      investment = create(:budget_investment, budget: budget)

      expect(polymorphic_index(investment, search: "New")).to eq budget_investments_path(budget, search: "New")
    end
  end

  describe "admin_polymorphic_path" do
    include ActionDispatch::Routing::UrlFor

    it "routes budget investments" do
      budget = create(:budget)
      investment = create(:budget_investment, budget: budget)

      expect(admin_polymorphic_path(investment)).to eq(
        admin_budget_budget_investment_path(budget, investment)
      )
    end

    it "routes budget groups" do
      budget = create(:budget)
      group = create(:budget_group, budget: budget)

      expect(admin_polymorphic_path(group)).to eq(admin_budget_group_path(budget, group))
    end

    it "routes budget headings" do
      budget = create(:budget)
      group = create(:budget_group, budget: budget)
      heading = create(:budget_heading, group: group)

      expect(admin_polymorphic_path(heading)).to eq(
        admin_budget_group_heading_path(budget, group, heading)
      )
    end

    it "routes poll booths" do
      booth = create(:poll_booth)

      expect(admin_polymorphic_path(booth)).to eq(admin_booth_path(booth))
    end

    it "routes poll officers" do
      officer = create(:poll_officer)

      expect(admin_polymorphic_path(officer)).to eq admin_officer_path(officer)
    end

    it "routes poll questions" do
      question = create(:poll_question)

      expect(admin_polymorphic_path(question)).to eq(admin_question_path(question))
    end

    it "routes poll answer videos" do
      video = create(:poll_answer_video)

      expect(admin_polymorphic_path(video)).to eq admin_video_path(video)
    end

    it "routes milestones for resources with no hierarchy" do
      proposal = create(:proposal)
      milestone = create(:milestone, milestoneable: proposal)

      expect(admin_polymorphic_path(milestone)).to eq(
        admin_proposal_milestone_path(proposal, milestone)
      )
    end

    it "routes milestones for resources with hierarchy" do
      budget = create(:budget)
      investment = create(:budget_investment, budget: budget)
      milestone = create(:milestone, milestoneable: investment)

      expect(admin_polymorphic_path(milestone)).to eq(
        admin_budget_budget_investment_milestone_path(budget, investment, milestone)
      )
    end

    it "routes progress bars for resources with no hierarchy" do
      proposal = create(:proposal)
      progress_bar = create(:progress_bar, progressable: proposal)

      expect(admin_polymorphic_path(progress_bar)).to eq(
        admin_proposal_progress_bar_path(proposal, progress_bar)
      )
    end

    it "routes progress_bars for resources with hierarchy" do
      budget = create(:budget)
      investment = create(:budget_investment, budget: budget)
      progress_bar = create(:progress_bar, progressable: investment)

      expect(admin_polymorphic_path(progress_bar)).to eq(
        admin_budget_budget_investment_progress_bar_path(budget, investment, progress_bar)
      )
    end

    it "routes audits" do
      budget = create(:budget)
      investment = create(:budget_investment, budget: budget)
      audit = investment.audits.create!

      expect(admin_polymorphic_path(audit)).to eq(
        admin_budget_budget_investment_audit_path(budget, investment, audit)
      )
    end

    it "routes booth assignments" do
      poll = create(:poll)
      assignment = create(:poll_booth_assignment, poll: poll)

      expect(admin_polymorphic_path(assignment)).to eq(
        admin_poll_booth_assignment_path(poll, assignment)
      )
    end

    it "routes poll shifts" do
      booth = create(:poll_booth)
      shift = create(:poll_shift, booth: booth)

      expect(admin_polymorphic_path(shift)).to eq(admin_booth_shift_path(booth, shift))
    end

    it "supports routes for actions like edit" do
      proposal = create(:proposal)
      milestone = create(:milestone, milestoneable: proposal)

      expect(admin_polymorphic_path(milestone, action: :edit)).to eq(
        edit_admin_proposal_milestone_path(proposal, milestone)
      )
    end
  end
end

def polymorphic_path(record, options = {})
  super(record, options.merge(only_path: true))
end
