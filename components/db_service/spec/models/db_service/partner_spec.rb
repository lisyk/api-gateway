require 'rails_helper'

RSpec.describe DbService::Partner, type: :model do
  let(:valid_partner) { DbService::Partner.new(name: 'vcp', root_domain: 'vcp.vet') }
  let(:partner_no_domain) { DbService::Partner.new(name: 'vcp') }
  let(:partner_no_name) { DbService::Partner.new(root_domain: 'vcp.vet') }
  context 'presence' do
    it 'is valid with partner name and root_domain' do
      expect(valid_partner).to be_valid
    end
    it 'is not valid without root_domain' do
      expect(partner_no_domain).not_to be_valid
      expect(partner_no_domain.errors[:root_domain]).to include "can't be blank"
    end
    it 'is not valid without name' do
      expect(partner_no_name).not_to be_valid
      expect(partner_no_name.errors[:name]).to include "can't be blank"
    end
  end

  context 'uniqueness' do
    let(:name_exists) { DbService::Partner.new(name: 'vcp', root_domain: 'wellness.com') }
    let(:domain_exists) { DbService::Partner.new(name: 'wellness_partner', root_domain: 'vcp.vet') }
    let(:all_uniq) { DbService::Partner.new(name: 'wellness_partner', root_domain: 'wellness.com') }

    it 'is valid with uniq partner name and domain' do
      expect(all_uniq).to be_valid
    end
    it 'is not valid with duplicate partner name' do
      valid_partner.save!
      name_exists.valid?
      expect(name_exists.errors[:name]).to include "has already been taken"
    end
    it 'is not valid with duplicate root_domain' do
      valid_partner.save!
      name_exists.valid?
      expect(name_exists.errors[:name]).to include "has already been taken"
    end
  end
end
