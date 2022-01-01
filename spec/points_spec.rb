# frozen_string_literal: true

require 'points'
require 'frame'

describe Points do
  # need to return to making this frame a double
  # let(:frame) { double('frame', :update_roll => true, :rolls => [4, 3] ) }
  let(:points) { Points.new }

  describe '#initialize' do
    it 'sets up instance variables for the total score summation and a score breakdown per frame' do
      expect(points.current_score).to eq 0
      expect(points.frames).to be_an Array
      expect(points.frames.length).to eq 10
      expect(points.frames.first).to be_an_instance_of Frame
    end
  end

  describe '#update_roll(current_frame, current_roll, pins_knocked_down)' do
    it 'sends a message to relevant frame instance to update roll score' do      
      expect(points.frames.first).to receive(:update_roll)

      points.update_roll(1, 1, 4)
    end

    it 'updates current score if on roll 2' do
      expect(points).to receive(:update_total)

      points.update_roll(1, 1, 5)
      points.update_roll(1, 2, 5)
    end

    it 'updates current score if a strike occured' do
      expect(points).to receive(:update_total)

      points.update_roll(1, 1, 10)
    end
  end

  describe '#update_total(score)' do
    it 'adds score for completed frame onto total score instance variable' do
      expect { points.update_total(9) }.to change { points.current_score }.from(0).to(9)
    end
  end

  describe '#add_bonus_points_for_last_frame(current_frame_number)' do
    it 'updates current score with any bonus points from a strike' do
      points.update_roll(1, 1, 10)
      points.update_roll(2, 1, 3)
      points.update_roll(2, 2, 4)

      expect { points.add_bonus_points_for_last_frame(2) }.to change { points.current_score }.from(17).to(24)
    end
  end

  describe '#score_breakdown' do
    it 'offers a visual breakdown of the games scores' do
      # cant work out how to do this with a stub on frames
      points.update_roll(1, 1, 4)
      points.update_roll(1, 2, 3)

      expect(points.score_breakdown).to eq "Frame | Pins | Bonus    \n=====================\n  1  | 4 , 3 |  0\n  2  |  ,  |  0\n  3  |  ,  |  0\n  4  |  ,  |  0\n  5  |  ,  |  0\n  6  |  ,  |  0\n  7  |  ,  |  0\n  8  |  ,  |  0\n  9  |  ,  |  0\n  10  |  ,  |  0\n"
    end
  end

  describe '#reset' do
    it 'resets the score instance variables back to zero' do
      # ideally - a new instance of points would be made so that the whole round is kept together
      points.update_roll(1, 1, 4)
      points.update_roll(1, 2, 3)

      expect(points.current_score).to eq 7
      expect(points.frames.first.rolls.length).to eq 2
      expect(points.frames.first.rolls[0]).to eq 4
      expect(points.frames.first.rolls[1]).to eq 3

      points.reset

      expect(points.current_score).to eq 0
      expect(points.frames.first.rolls).to be_empty
    end
  end
end
