defmodule UtrustChallengeWeb.Helpers do
  use Phoenix.HTML

  def last_updated_txt(record) do
    time_diff = Timex.diff(Timex.now, record.updated_at, :minutes)
    case time_diff > 0 do
      true ->
        humanized_time =
          Timex.Duration.from_minutes(time_diff)
          |> Timex.format_duration(:humanized)
        "#{humanized_time} ago"
      false ->
        "less than a minute ago"
    end
  end

  def class_for_payment_completed(%{status: :confirmed}), do: "completed"
  def class_for_payment_completed(_), do: ""
end
