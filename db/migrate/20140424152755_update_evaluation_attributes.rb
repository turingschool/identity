class UpdateEvaluationAttributes < ActiveRecord::Migration
  def change
    Evaluation.all.each do |evaluation|

      evaluation.title = case evaluation.title
                         when 'Initial Review',    'Initial Evaluation' then 'Initial Evaluation'
                         when 'Interview Notes',   'Interview'          then 'Interview'
                         when 'Logical Reasoning', 'Logic Evaluation'   then 'Logic Evaluation'
                         else
                           raise "Unexpected title: #{evaluation.title.inspect}"
                         end

      evaluation.slug =  case evaluation.slug
                         when 'triage',    'initial_evaluation' then 'initial_evaluation'
                         when 'selection', 'interview'          then 'interview'
                         when 'logic',     'logic_evaluation'   then 'logic_evaluation'
                         else
                           raise "Unexpected slug: #{evaluation.slug.inspect}"
                         end
      evaluation.save!
    end
  end
end
