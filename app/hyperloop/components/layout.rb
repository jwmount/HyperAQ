class Layout < Hyperloop::Component
  render (DIV)  do
    DIV(class: "container-fluid") do
      DIV(class: "row") do
#     <div class="col-sm-6" style="background-color:lavender;">Sprinkles</div>
        DIV(class: "col-sm-6") do
          SprinkleList {}
        end
#     <div class="col-sm-6" style="background-color:lavenderblush;">History</div>
        DIV(class: "col-sm-6") do
          HistoryList {}
        end
      end
    end

  end
end
