require 'spec_helper'

describe Spree::State, type: :model do
  let(:america) { create :country }
  let(:state) { create(:state, name: 'California', abbr: 'CA', country: america) }

  before { america.states << state }

  describe 'Associations' do
    it { is_expected.to have_many(:addresses).dependent(:restrict_with_error) }
  end

  describe 'Validations' do
    describe '#ensure_country_states_required?' do
      it { expect(state.valid?).to be_truthy }

      context 'states_required unchecked' do
        before { america.states_required = false }
        it { expect(state.valid?).to be_falsy }
      end
    end
  end

  it "can find a state by name or abbr" do
    expect(Spree::State.find_all_by_name_or_abbr("California")).to include(state)
    expect(Spree::State.find_all_by_name_or_abbr("CA")).to include(state)
  end

  it "can find all states group by country id" do
    expect(Spree::State.states_group_by_country_id).to eq({ state.country_id.to_s => [[state.id, state.name]] })
  end

  describe 'whitelisted_ransackable_attributes' do
    it { expect(Spree::State.whitelisted_ransackable_attributes).to eq(%w(abbr)) }
  end
end
