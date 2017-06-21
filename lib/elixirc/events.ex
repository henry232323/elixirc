defmodule Elixirc.Events do
  @events %{
    "001" => :welcome,
    "002" => :yourhost,
    "003" => :created,
    "004" => :myinfo,
    "005" => :featurelist,  # XXX,
    "010" => :toomanypeeps,
    "200" => :tracelink,
    "201" => :traceconnecting,
    "202" => :tracehandshake,
    "203" => :traceunknown,
    "204" => :traceoperator,
    "205" => :traceuser,
    "206" => :traceserver,
    "207" => :traceservice,
    "208" => :tracenewtype,
    "209" => :traceclass,
    "210" => :tracereconnect,
    "211" => :statslinkinfo,
    "212" => :statscommands,
    "213" => :statscline,
    "214" => :statsnline,
    "215" => :statsiline,
    "216" => :statskline,
    "217" => :statsqline,
    "218" => :statsyline,
    "219" => :endofstats,
    "221" => :umodeis,
    "231" => :serviceinfo,
    "232" => :endofservices,
    "233" => :service,
    "234" => :servlist,
    "235" => :servlistend,
    "241" => :statslline,
    "242" => :statsuptime,
    "243" => :statsoline,
    "244" => :statshline,
    "250" => :luserconns,
    "251" => :luserclient,
    "252" => :luserop,
    "253" => :luserunknown,
    "254" => :luserchannels,
    "255" => :luserme,
    "256" => :adminme,
    "257" => :adminloc1,
    "258" => :adminloc2,
    "259" => :adminemail,
    "261" => :tracelog,
    "262" => :endoftrace,
    "263" => :tryagain,
    "265" => :n_local,
    "266" => :n_global,
    "300" => :none,
    "301" => :away,
    "302" => :userhost,
    "303" => :ison,
    "305" => :unaway,
    "306" => :nowaway,
    "311" => :whoisuser,
    "312" => :whoisserver,
    "313" => :whoisoperator,
    "314" => :whowasuser,
    "315" => :endofwho,
    "316" => :whoischanop,
    "317" => :whoisidle,
    "318" => :endofwhois,
    "319" => :whoischannels,
    "321" => :liststart,
    "322" => :list,
    "323" => :listend,
    "324" => :channelmodeis,
    "329" => :channelcreate,
    "331" => :notopic,
    "332" => :currenttopic,
    "333" => :topicinfo,
    "341" => :inviting,
    "342" => :summoning,
    "346" => :invitelist,
    "347" => :endofinvitelist,
    "348" => :exceptlist,
    "349" => :endofexceptlist,
    "351" => :version,
    "352" => :whoreply,
    "353" => :namreply,
    "361" => :killdone,
    "362" => :closing,
    "363" => :closeend,
    "364" => :links,
    "365" => :endoflinks,
    "366" => :endofnames,
    "367" => :banlist,
    "368" => :endofbanlist,
    "369" => :endofwhowas,
    "371" => :info,
    "372" => :motd,
    "373" => :infostart,
    "374" => :endofinfo,
    "375" => :motdstart,
    "376" => :endofmotd,
    "377" => :motd2,        # 1997-10-16 -- tkil,
    "381" => :youreoper,
    "382" => :rehashing,
    "384" => :myportis,
    "391" => :time,
    "392" => :usersstart,
    "393" => :users,
    "394" => :endofusers,
    "395" => :nousers,
    "401" => :nosuchnick,
    "402" => :nosuchserver,
    "403" => :nosuchchannel,
    "404" => :cannotsendtochan,
    "405" => :toomanychannels,
    "406" => :wasnosuchnick,
    "407" => :toomanytargets,
    "409" => :noorigin,
    "411" => :norecipient,
    "412" => :notexttosend,
    "413" => :notoplevel,
    "414" => :wildtoplevel,
    "421" => :unknowncommand,
    "422" => :nomotd,
    "423" => :noadmininfo,
    "424" => :fileerror,
    "431" => :nonicknamegiven,
    "432" => :erroneusnickname, # Thiss iz how its speld in thee RFC.,
    "433" => :nicknameinuse,
    "436" => :nickcollision,
    "437" => :unavailresource,  # "Nick temporally unavailable",
    "441" => :usernotinchannel,
    "442" => :notonchannel,
    "443" => :useronchannel,
    "444" => :nologin,
    "445" => :summondisabled,
    "446" => :usersdisabled,
    "451" => :notregistered,
    "461" => :needmoreparams,
    "462" => :alreadyregistered,
    "463" => :nopermforhost,
    "464" => :passwdmismatch,
    "465" => :yourebannedcreep, # I love this one...,
    "466" => :youwillbebanned,
    "467" => :keyset,
    "471" => :channelisfull,
    "472" => :unknownmode,
    "473" => :inviteonlychan,
    "474" => :bannedfromchan,
    "475" => :badchannelkey,
    "476" => :badchanmask,
    "477" => :nochanmodes,  # "Channel doesn't support modes",
    "478" => :banlistfull,
    "481" => :noprivileges,
    "482" => :chanoprivsneeded,
    "483" => :cantkillserver,
    "484" => :restricted,   # Connection is restricted,
    "485" => :uniqopprivsneeded,
    "491" => :nooperhost,
    "492" => :noservicehost,
    "501" => :umodeunknownflag,
    "502" => :usersdontmatch,
    "dcc_connect" => :dcc_connect,
    "dcc_disconnect" => :dcc_disconnect,
    "dccmsg" => :dccmsg,
    "disconnect" => :disconnect,
    "ctcp" => :ctcp,
    "ctcpreply" => :ctcpreply,
    "error" => :error,
    "join" => :join,
    "kick" => :kick,
    "mode" => :mode,
    "part" => :part,
    "ping" => :ping,
    "notice" => :notice,
    "privmsg" => :privmsg,
    "privnotice" => :privnotice,
    "pubmsg" => :pubmsg,
    "pubnotice" => :pubnotice,
    "quit" => :quit,
    "invite" => :invite,
    "pong" => :pong,
  }

  def events do
     @events
  end

  def check_args(args) do
    len = length(args) - 1
    if len do
      check_args(args, 0, len)
    else
      args
    end
  end

  def check_args(args, idx, total) do
    if idx <= total do
      if String.starts_with?(Enum.at(args, idx), ":") do
        Enum.slice(args, 0..idx) ++ Enum.join(Enum.slice(args, idx..length(args)-1), " ")
      else
        check_args(args, idx+1, total)
      end
    else
      args
    end
  end

  def parse(message) do
    message = String.strip(message)
    parts = String.split(message)
    [command|args] = parts
    prefix = nil
    if String.starts_with?(command, ":") do
      [_prefix | [command | args]] = parts
      #prefix = String.replace_prefix(prefix, ":", "")
    end

    command = String.downcase(command)
    args = Elixirc.Events.check_args(args)

    if Map.has_key?(Elixirc.Events.events, command) do
      {Elixirc.Events.events[command], args}
    else
      {command, args}
    end
  end
end
