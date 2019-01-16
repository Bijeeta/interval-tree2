
SortedList = require './sorted-list'
Node       = require './node'
Point      = require './point'
Interval   = require './interval'
Util       = require './util'


###*
interval tree

@class IntervalTree
@module interval-tree2
###
class IntervalTree


    ###*
    @constructor
    @param {Number} center center of the root node
    ###
    constructor: (@center) ->

        Util.assertNumber @center, 'IntervalTree: center'

        ###*
        center => node

        @property {Object(Node)} nodesByCenter
        ###
        @nodesByCenter = {}


        ###*
        create root node
        ###
        @createNode(@center)




    ###*
    add one interval

    @method add
    @public
    @param {Number} start start of the interval to create
    @param {Number} end   end of the interval to create
    @param {String|Number} [id] identifier to distinguish intervals. Automatically defiend when not set.
    @return {Interval}
    ###
    add: (start, end, id) ->

        #if @intervalsById[id]?
        #    throw new Error('id ' + id + ' is already registered.')

        #if not id?
        #    while @intervalsById[@idCandidate]?
        #        @idCandidate++
        #    id = @idCandidate


        Util.assertNumber(start, '1st argument of IntervalTree#add()')
        Util.assertNumber(end, '2nd argument of IntervalTree#add()')

        if start >= end
            Util.assertOrder(start, end, 'start', 'end')

    
        interval = new Interval(start, end, id)
        
       # @pointTree.insert new Point(interval.start, id)
       # @pointTree.insert new Point(interval.end,   id)

        #@intervalsById[id] = JSON.stringify(interval)

        return @insert interval, @center

    
    ###*
    get intervals whose start position is less than or equal to the given value

    @method startPointSearch
    @param {Number} val
    @return {Array(Interval)}
    ###
    startPointSearch: (starts_sorted,val) ->
        
        index = starts_sorted.lastPositionOf(start: val)

        return starts_sorted.slice(0, index + 1)


    ###*
    get intervals whose end position is more than or equal to the given value

    @method endPointSearch
    @param {Number} val
    @return {Array(Interval)}
    ###
    endPointSearch: (ends_sorted,val) ->

        index = ends_sorted.firstPositionOf(end: val)

        return ends_sorted.slice(index)

    ###*
    search intervals at the given node

    @method pointSearch
    @public
    @param {Number} val
    @param {Node} [node] current node to search. default is this.root
    @return {Array(Interval)}
    ###
    pointSearch: (val, center = @center, results = []) ->
        node = JSON.parse(@nodesByCenter[center])
        
        Util.assertNumber(val, '1st argument of IntervalTree#pointSearch()')
       
        if val < node.center
            starts_sorted = @create_list(node.starts,'start')
       
            results = results.concat @startPointSearch(starts_sorted,val)

            if node.left?
                return @pointSearch(val, node.left, results)

            else
                return results


        if val > node.center

            ends_sorted = @create_list(node.ends,'end')
            results = results.concat @endPointSearch(ends_sorted,val)
            
            if node.right?
                return @pointSearch(val, node.right, results)

            else
                return results

        # if val is node.center
        return results.concat node.getAllIntervals()


   ###*
   create Sorted List from elements
    @method create_list
    @private
    @param {List} elems
    @param {String} type of val
    @return {SortedList} created sorted list
   ###
    create_list: (elems, val) ->
        nlist = new SortedList(val)
        for elem in elems    
            nlist.insert(elem)
         return nlist   
        
    ###*
    insert interval to the given node

    @method insert
    @private
    @param {Interval} interval
    @param {Node} node node to insert the interval
    @return {Interval} inserted interval
    ###
    insert: (interval, center) ->
        
        node = JSON.parse(@nodesByCenter[center])
        
        if interval.end < node.center
            
            if not node.left?
                left_node = @createNode(interval.end)
                node.left = left_node.center
                @nodesByCenter[center] = JSON.stringify(node)
            #node.left ?= @createNode(interval.end)

            return @insert(interval, node.left)

        if node.center < interval.start

            if not node.right? 
                right_node = @createNode(interval.start)
                node.right = right_node.center
                @nodesByCenter[center] = JSON.stringify(node)
            return @insert(interval, node.right)

        starts_sorted = @create_list(node.starts,'start')
        ends_sorted = @create_list(node.ends,'end')
        
        starts_sorted.insert interval
        ends_sorted.insert interval
        
        node.starts = starts_sorted
        node.ends = ends_sorted
        @nodesByCenter[center] = JSON.stringify(node)

        return interval



    ###*
    create node by center

    @method createNode
    @private
    @param {Number} center
    @return {Node} node
    ###
    createNode: (center) ->

        node = new Node(center)

        @nodesByCenter[center] = JSON.stringify(node)

        return node


module.exports = IntervalTree
