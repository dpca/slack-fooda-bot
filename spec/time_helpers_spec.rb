describe TimeHelpers do
  describe '.today?' do
    it "returns true if it's today" do
      expect(TimeHelpers.today?(Time.new)).to be true
    end

    it "returns false if it's yesterday" do
      expect(TimeHelpers.today?(Time.new - 86400)).to be false
    end

    it "returns false if it's tomorrow" do
      expect(TimeHelpers.today?(Time.new + 86400)).to be false
    end
  end

  describe '.tomorrow?' do
    it "returns false if it's today" do
      expect(TimeHelpers.tomorrow?(Time.new)).to be false
    end

    it "returns false if it's yesterday" do
      expect(TimeHelpers.tomorrow?(Time.new - 86400)).to be false
    end

    it "returns true if it's tomorrow" do
      expect(TimeHelpers.tomorrow?(Time.new + 86400)).to be true
    end
  end
end
