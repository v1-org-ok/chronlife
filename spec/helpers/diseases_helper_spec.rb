require 'rails_helper'

RSpec.describe DiseasesHelper, type: :helper do
  describe '#severity_to_string' do
    it 'returns the correct translation for severity 1' do
      expect(helper.severity_to_string(1)).to eq(I18n.t('diseases.severity.one'))
    end

    it 'returns the correct translation for severity 2' do
      expect(helper.severity_to_string(2)).to eq(I18n.t('diseases.severity.two'))
    end

    it 'returns the correct translation for severity 3' do
      expect(helper.severity_to_string(3)).to eq(I18n.t('diseases.severity.three'))
    end

    it 'returns the correct translation for severity 4' do
      expect(helper.severity_to_string(4)).to eq(I18n.t('diseases.severity.four'))
    end

    it 'returns the correct translation for severity 5' do
      expect(helper.severity_to_string(5)).to eq(I18n.t('diseases.severity.five'))
    end

    it 'returns the correct translation for unknown severity' do
      expect(helper.severity_to_string(0)).to eq(I18n.t('diseases.severity.unknown'))
      expect(helper.severity_to_string(6)).to eq(I18n.t('diseases.severity.unknown'))
    end
  end
end