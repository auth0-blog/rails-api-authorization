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
end