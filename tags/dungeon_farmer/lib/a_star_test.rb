require 'rubygems'
require 'gratr'
require 'gratr/import'
require 'profiler'


class AStarTest
  def initialize
    
  end
  
  def self.test
    # Graph from "Artificial Intelligence: A Modern Approach" by Stuart
    # Russell ande Peter Norvig, Prentice-Hall 2nd Edition, pg 63
    romania = UndirectedGraph.new.
      add_edge!('Oradea',         'Zerind',          71).
      add_edge!('Oradea',         'Sibiu',          151).
      add_edge!('Zerind',         'Arad',            75).
      add_edge!('Arad',           'Sibiu',           99).
      add_edge!('Arad',           'Timisoara',      138).
      add_edge!('Timisoara',      'Lugoj',          111).
      add_edge!('Lugoj',          'Mehadia',         70).
      add_edge!('Mehadia',        'Dobreta',         75).
      add_edge!('Dobreta',        'Craiova',        120).
      add_edge!('Sibiu',          'Fagaras',         99).
      add_edge!('Fagaras',        'Bucharest',      211).
      add_edge!('Sibiu',          'Rimnicu Vilcea',  80).
      add_edge!('Rimnicu Vilcea', 'Craiova',        146).
      add_edge!('Rimnicu Vilcea', 'Pitesti',         97).
      add_edge!('Craiova',        'Pitesti',        138).
      add_edge!('Pitesti',        'Bucharest',      101).
      add_edge!('Bucharest',      'Giurgin',         90).
      add_edge!('Bucharest',      'Urzieni',         85).
      add_edge!('Urzieni',        'Hirsova',         98).
      add_edge!('Urzieni',        'Vaslui',         142).
      add_edge!('Hirsova',        'Eforie',          86).
      add_edge!('Vaslui',         'Iasi',            92).
      add_edge!('Iasi',           'Neamt',           87)

    # Heuristic from "Artificial Intelligence: A Modern Approach" by Stuart
    # Russell ande Peter Norvig, Prentice-Hall 2nd Edition, pg 95
    straight_line_to_Bucharest = 
    {
      'Arad'           => 366,
      'Bucharest'      =>   0,
      'Craiova'        => 160,
      'Dobreta'        => 242,
      'Eforie'         => 161,
      'Fagaras'        => 176,
      'Giurgiu'        =>  77,
      'Hirsova'        => 151,
      'Iasi'           => 226,
      'Lugoj'          => 244,
      'Mehadia'        => 241,
      'Neamt'          => 234,
      'Oradea'         => 380,
      'Pitesti'        => 100,
      'Rimnicu Vilcea' => 193,
      'Sibiu'          => 253,
      'Timisoara'      => 329,
      'Urziceni'       =>  80,
      'Vaslui'         => 199,
      'Zerind'         => 374
    }

    # Heuristic is distance as crow flies, always under estimates costs.
    h   = Proc.new {|v| straight_line_to_Bucharest[v]}

    list = []

    dv  = Proc.new {|v| list << "dv #{v}" }
    ev  = Proc.new {|v| list << "ev #{v}" }
    bt  = Proc.new {|v| list << "bt #{v}" }
    fv  = Proc.new {|v| list << "fv #{v}" }
    er  = Proc.new {|e| list << "er #{e}" }
    enr = Proc.new {|e| list << "enr #{e}" }
 
    options = { :discover_vertex  => dv,
                :examine_vertex   => ev,
                :black_target     => bt,
                :finish_vertex    => fv,
                :edge_relaxed     => er,
                :edge_not_relaxed => enr }
    
    Profiler__::start_profile
    100.times { romania.astar('Arad', 'Bucharest', h, {}) }
    Profiler__::print_profile($>)

#    puts result
    # This isn't the greatest test since the exact ordering is not
    # not specified by the algorithm. If someone has a better idea, please fix
#    assert_equal ["ev Arad",
#     "er (Arad=Sibiu '99')",
#     "dv Sibiu",
#     "er (Arad=Timisoara '138')",
#     "dv Timisoara",
#     "er (Arad=Zerind '75')",
#     "dv Zerind",
#     "fv Arad",
#     "ev Sibiu",
#     "er (Rimnicu Vilcea=Sibiu '80')",
#     "dv Rimnicu Vilcea",
#     "er (Fagaras=Sibiu '99')",
#     "dv Fagaras",
#     "er (Oradea=Sibiu '151')",
#     "dv Oradea",
#     "enr (Arad=Sibiu '99')",
#     "fv Sibiu",
#     "ev Rimnicu Vilcea",
#     "enr (Rimnicu Vilcea=Sibiu '80')",
#     "er (Craiova=Rimnicu Vilcea '146')",
#     "dv Craiova",
#     "er (Pitesti=Rimnicu Vilcea '97')",
#     "dv Pitesti",
#     "fv Rimnicu Vilcea",
#     "ev Fagaras",
#     "enr (Fagaras=Sibiu '99')",
#     "er (Bucharest=Fagaras '211')",
#     "dv Bucharest",
#     "fv Fagaras",
#     "ev Pitesti",
#     "enr (Pitesti=Rimnicu Vilcea '97')",
#     "er (Bucharest=Pitesti '101')",
#     "enr (Craiova=Pitesti '138')",
#     "fv Pitesti",
#     "ev Bucharest"], 
#     puts list
  end
end

if __FILE__ == $0
  AStarTest.test
end
