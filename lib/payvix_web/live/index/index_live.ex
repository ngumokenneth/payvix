defmodule PayvixWeb.IndexLive.Index do
  use PayvixWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="lg:grid grid-cols-2 overflow-hidden">
      <div class="bg-rose-600 h-screen hidden lg:block">
        <img src={~p"/images/Frame 3.png"} alt="" />
      </div>

      <div class="flex flex-col items-center">
        <div class="flex gap-4 items-center">
          <img src={~p"/images/logo.svg"} />
          <span class="text-[3.5rem] font-bold text-[#7C5DFA]">Invoice</span>
        </div>
        <h1 class="md:text-4xl md:font-semibold">Sign in to Invoice</h1>
        <div class="flex justify-center gap-4 w-full border-[#DFE3FA] border-2 py-2 md:py-3 mt-12 rounded-3xl md:rounded-xl md:mx-auto md:max-w-sm">
          <img src={~p"/images/google.svg"} />
          <span class="text-lg text-[#3F445F]">Sign In With Google</span>
        </div>
        <div class="flex justify-center gap-4 w-full border-[#DFE3FA] border-2 py-2 md:py-3 my-12 rounded-3xl md:rounded-xl md:mx-auto md:max-w-sm">
          <img src={~p"/images/email.svg"} />
          <span class="text-lg text-[#3F445F]">Sign In With Email</span>
        </div>
        <div class="text-center">
          <p class="text-lg text-[#888EB0]">By creating an account, you agree to</p>
          <p class="text-lg text-[#888EB0]">Payvix company’s</p>
          <span class="text-lg font-bold text-[#888EB0]">Terms of use </span><span class="text-lg text-[#888EB0]">and </span><span class="text-lg font-bold text-[#888EB0]">Privacy Policy.</span>
        </div>
      </div>
    </div>
    """
  end
end
