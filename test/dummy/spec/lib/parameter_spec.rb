# frozen_string_literal: true

RSpec.describe Rparam::Parameter do

  describe 'param' do

    describe 'type: Date' do

      it 'delimited by -' do
        params = ActionController::Parameters.new(date: '2018-01-01')
        parameter = Rparam::Parameter.new(params)
        parameter.send(:param, :date, type: Date)
        expect(params[:date]).to eq Date.new(2018, 1, 1)
      end

      it 'delimited by /' do
        params = ActionController::Parameters.new(date: '2018/02/02')
        parameter = Rparam::Parameter.new(params)
        parameter.send(:param, :date, type: Date)
        expect(params[:date]).to eq Date.new(2018, 2, 2)
      end

      it 'invalid date' do
        params = ActionController::Parameters.new(date: 'invalid')
        parameter = Rparam::Parameter.new(params)
        parameter.send(:param, :date, type: Date)
        expect(params[:date]).to eq nil
      end

      it 'nil' do
        params = ActionController::Parameters.new(date: nil)
        parameter = Rparam::Parameter.new(params)
        parameter.send(:param, :date, type: Date)
        expect(params[:date]).to eq nil
      end

      describe 'with default value' do

        it 'valid date' do
          params = ActionController::Parameters.new(date: '2018-03-03')
          parameter = Rparam::Parameter.new(params)
          default = Date.today
          parameter.send(:param, :date, type: Date, default: default)
          expect(params[:date]).to eq Date.new(2018, 3, 3)
        end

        it 'invalid date' do
          params = ActionController::Parameters.new(date: 'invalid')
          parameter = Rparam::Parameter.new(params)
          default = Date.today
          parameter.send(:param, :date, type: Date, default: default)
          expect(params[:date]).to eq default
        end

      end

      describe 'without default value' do

        it 'valid date' do
          params = ActionController::Parameters.new(date: '2018-04-04')
          parameter = Rparam::Parameter.new(params)
          parameter.send(:param, :date, type: Date)
          expect(params[:date]).to eq Date.new(2018, 4, 4)
        end

        it 'invalid date' do
          params = ActionController::Parameters.new(date: 'invalid')
          parameter = Rparam::Parameter.new(params)
          parameter.send(:param, :date, type: Date)
          expect(params[:date]).to eq nil
        end

      end

    end

  end

end
