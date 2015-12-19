defmodule ClassSearch.Periodically do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, {})
  end

  def init(state) do
    Process.send_after(self(), :work, 2 * 60 * 60 * 1000) # In 2 hours
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here

    # Fetch and update course listings.

    # Shoot off email alerts to various users alerting them about their courses
    # having spots open.

    # ? ? ? ? ? 

    # Alerting users of a price drop for books?

    # Any other tasks that need to be done. 
    # Start the timer again
    Process.send_after(self(), :work, 2 * 60 * 60 * 1000) # In 2 hours

    {:noreply, state}
  end
end
