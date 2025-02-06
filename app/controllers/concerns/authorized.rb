# frozen_string_literal: true

module Authorized
  extend ActiveSupport::Concern

  def authorized?(user, relations, object)
    if relations.size == 1
      OpenfgaService.check("user:#{user.id}", relation, "report:#{object.id}")
    else
      OpenfgaService.batch_check_relations("user:#{user.id}", relations,"report:#{object.id}")
    end
  end

  def reports(user, relation)
    return [] unless %w[submitter approver].include?(relation)

    OpenfgaService.list_objects(user, relation)
  end

  def update_authorization_manager(manager_id, relation, object)
    OpenfgaService.update_relation("user:#{manager_id}", relation, "user:#{object.id}")
  end

  def update_authorization_submitter(submitter_id, object)
    OpenfgaService.update_relation("user:#{submitter_id}", "submitter", "report:#{object.id}")
  end
end