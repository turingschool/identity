class UpdateEvaluationAttributes < ActiveRecord::Migration
  def change
    Evaluation.all.each do |evaluation|

      evaluation.title = case evaluation.title
                         when 'Initial Review'    then 'Initial Evaluation'
                         when 'Interview Notes'   then 'Interview'
                         when 'Logical Reasoning' then 'Logic Evaluation'
                         else
                           raise "Unexpected title: #{evaluation.title.inspect}"
                         end

      evaluation.slug =  case evaluation.slug
                         when 'triage'    then 'initial_evaluation'
                         when 'selection' then 'interview'
                         when 'logic'     then 'logic_evaluation'
                         else
                           raise "Unexpected slug: #{evaluation.slug.inspect}"
                         end

      evaluation.save!
    end
  end
end
