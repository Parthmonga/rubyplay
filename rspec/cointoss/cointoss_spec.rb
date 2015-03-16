describe Game do
  player1 = Player.new("Bob", "X")
  player2 = Player.new("Joe", "O")
  interface = Interface.new
  subject {Game.new(player1, player2, interface)}

  describe "#new" do
    it "creates an instance of Game" do
      expect(subject).to be_an_instance_of(Game)
    end
    it "selects a player to go first" do
      allow_any_instance_of(Interface).to receive(:get_coin_call).and_return("HEADS")
      expect(subject.turn).to be_an_instance_of(Player)
    end
    it "gets correct player from matching coin toss" do 
      allow(subject).to receive(:caller).with(player1)
      allow(interface).to receive(:get_coin_call).and_return("HEADS")
      allow(subject).to receive(:flip).with("HEADS")
      expect(subject.turn).to eql(player1)
    end
    it "gets correct player from missed coin toss" do 
      expect(subject).to receive(:caller).and_return(player1)
      allow(interface).to receive(:get_coin_call).and_return("HEADS")
      allow(subject).to receive(:flip).and_return("TAILS")
      expect(subject.turn).to eql(player2)
    end
  end
end
