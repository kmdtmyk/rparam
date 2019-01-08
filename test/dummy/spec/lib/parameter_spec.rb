# frozen_string_literal: true

RSpec.describe Rparam::Parameter do

  describe 'param' do

    let(:parameter){ Rparam::Parameter.new(params) }

    describe 'type: Date' do

      let(:params){ ActionController::Parameters.new(date: date) }
      let(:options){ { type: Date } }

      subject do
        parameter.send(:param, :date, **options)
        params[:date]
      end

      context 'delimited by -' do
        let(:date){ '2018-01-01' }
        it{ expect(subject).to eq Date.new(2018, 1, 1) }
      end

      context 'delimited by /' do
        let(:date){ '2018/02/02' }
        it{ expect(subject).to eq Date.new(2018, 2, 2) }
      end

      context 'invalid date' do
        let(:date){ 'invalid' }
        it{ expect(subject).to eq nil }
      end

      context 'nil' do
        let(:date){ nil }
        it{ expect(subject).to eq nil }
      end

      describe 'with default value' do

        let(:default){ Date.today }
        let(:options){ { type: Date, default: default } }

        context 'valid date' do
          let(:date){ '2018-03-03' }
          it{ expect(subject).to eq Date.new(2018, 3, 3) }
        end

        context 'invalid date' do
          let(:date){ 'invalid' }
          it{ expect(subject).to eq default }
        end

      end

      describe 'without default value' do

        let(:options){ { type: Date } }

        context 'valid date' do
          let(:date){ '2018-04-04' }
          it{ expect(subject).to eq Date.new(2018, 4, 4) }
        end

        context 'invalid date' do
          let(:date){ 'invalid' }
          it{ expect(subject).to eq nil }
        end

      end

    end

  end

end
