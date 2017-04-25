package snow.app.model {
	
	import snow.app.event.DataChangeEvent
	import snow.app.event.DataChangeType	
	import flash.events.EventDispatcher;

	public class DataProvider extends EventDispatcher {
				
		public var data:Vector.<Object>;
		
			
		public static const ASC:String = "ASC";
		
		public static const DESC:String = "DESC";
	
		public function DataProvider(value:Vector.<Object>=null) {			
			if (value == null) {
				data = new Vector.<Object>();
			} else {
				data = value;				
			}
		}	
		public function get length():uint {
			return data.length;
		}
	
		public function addItemAt(item:Object,index:uint):void {
			checkIndex(index,data.length);
			dispatchPreChangeEvent(DataChangeType.ADD,Vector.<Object>([item]),index,index);
			data.splice(index,0,item);
			dispatchChangeEvent(DataChangeType.ADD,Vector.<Object>([item]),index,index);
		}
			
		public function addItem(item:Object):void {
			dispatchPreChangeEvent(DataChangeType.ADD,Vector.<Object>([item]),data.length-1,data.length-1);
			data.push(item);
			dispatchChangeEvent(DataChangeType.ADD,Vector.<Object>([item]),data.length-1,data.length-1);
		}			
		public function addItemsAt(items:Array,index:uint):void {
			checkIndex(index,data.length);
			var arr:Vector.<Object> = Vector.<Object>(items);
			dispatchPreChangeEvent(DataChangeType.ADD,Vector.<Object>(arr),index,index+arr.length-1);			
			data.splice.apply(data, [index,0].concat(items));
			dispatchChangeEvent(DataChangeType.ADD,Vector.<Object>(arr),index,index+arr.length-1);
		}
			
		public function addItems(items:Array):void {
			addItemsAt(items,data.length);
		}
			
		public function concat(items:Array):void {
			addItems(items);
		}	
		
		public function getItemAt(index:uint):Object {
			checkIndex(index,data.length-1);
			return data[index];
		}	
		
		public function getItemIndex(item:Object):int {
			return data.indexOf(item);
		}
		/**
		 * 跟据属性名称查找指定对应数据对象
		 * @param	fieldName 需要查找的值
		 * @param	value 对应要查找的属性
		 * @return  返回数据对象
		 */
		public function getItemAtByField(fieldName:Object, value:*):Object {
			var i:int = 0;
			var obj:Object = null;
			for (i = 0; i < data.length; i++) {
				if (data[i][fieldName] == value) {
					obj = data[i];
					break;
				}
			}
			return obj;
		}
		/**
		 * 查找指定属性值的所有对应的数据对象
		 * @param	fieldName 需要查找的值
		 * @param	value 对应要查找的属性
		 * @param	blur  开启模糊查找
		 * @return  返回数据对象集
		 */
		public function getItemGroupField(fieldName:Object, value:*, blur:Boolean = false):DataProvider
		{
			var i:int = 0;
			var tempData:Vector.<Object> = new Vector.<Object>();
			for (i = 0; i < data.length; i++) {
				if (blur)
				{
					if (data[i][fieldName] != null&&data[i][fieldName]!="")
					{
					  var Content:String = (data[i][fieldName])
					  if (Content.indexOf(value) != -1)
				      {
						tempData.push(data[i])
					  }
					}
				}else
				{
				  if (data[i][fieldName] == value) {
					  tempData.push(data[i])
				  }
				}
			}
			return new DataProvider(tempData);
		}
		public function getItemIndexByField(fieldName:String, value:*):int {
			return data.indexOf(getItemAtByField(fieldName, value));
		}	
		
		public function removeItemAt(index:uint):Object {
			checkIndex(index,data.length-1);
			dispatchPreChangeEvent(DataChangeType.REMOVE, data.slice(index,index+1), index, index);
			var arr:Vector.<Object> = data.splice(index,1);
			dispatchChangeEvent(DataChangeType.REMOVE,arr,index,index);
			return arr[0];
		}
			
		public function removeItem(item:Object):Object {
			var index:int = getItemIndex(item);
			if (index != -1) {
				return removeItemAt(index);
			}
			return null;
		}
				
		public function removeAll():void {	
			var arr:Vector.<Object> = data.concat();			
			dispatchPreChangeEvent(DataChangeType.REMOVE_ALL, arr, 0, arr.length);			
			data.length = 0;
			dispatchChangeEvent(DataChangeType.REMOVE_ALL, data, 0, data.length);
		}		
		/**
		 * 替换数据
		 * @param	newItem
		 * @param	oldItem
		 * @return
		 */
		public function replaceItem(newItem:Object,oldItem:Object):Object {
			var index:int = getItemIndex(oldItem);
			if (index != -1) {
				return replaceItemAt(newItem,index);
			}
			return null;
		}
		/**
		 * 使用索引更换数据
		 * @param	newItem
		 * @param	index
		 * @return
		 */
		public function replaceItemAt(newItem:Object,index:uint):Object {
			checkIndex(index,data.length-1);
			var arr:Vector.<Object> = Vector.<Object>([data[index]]);
			dispatchPreChangeEvent(DataChangeType.REPLACE,arr,index,index);
			data[index] = newItem;
			dispatchChangeEvent(DataChangeType.REPLACE,arr,index,index);
			return arr[0];
		}
			
		public function sort(...sortArgs:Array):* {
			dispatchPreChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
			var returnValue:Vector.<Object> = data.sort.apply(data,sortArgs);
			dispatchChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
			return returnValue;
		}
		/**
		 * 用于排列
		 * @param	fieldName
		 * @param	order
		 * @return
		 */
		public function sortOn(fieldName:String, order:String = ASC):* {
			return sort(generateSortFunction(fieldName, order));
		}
		
		protected function generateSortFunction(sortField:String, order:String):Function {
			return function (x:*, y:*):Number {
				if (x[sortField] > y[sortField]) {
					return order == ASC ? 1 : -1;
				} else if (x[sortField] < y[sortField]) {
					return order == ASC ? -1 : 1;
				}
				return 0;
			}
		}	
		/**
		 * 返回副本,相当于复制一个
		 * @return
		 */
		public function clone():DataProvider {
			return new DataProvider(data.concat());
		}	
		public function toVector():Vector.<Object> {
			return data.concat();
		}	
		override public function toString():String {
			return "DataProvider ["+data.join(" , ")+"]";
		}		
		protected function checkIndex(index:int,maximum:int):void {
			if (index > maximum || index < 0) {
				throw new RangeError("DataProvider index ("+index+") is not in acceptable range (0 - "+maximum+")");
			}
		}

		protected function dispatchChangeEvent(evtType:String,items:Vector.<Object>,startIndex:int,endIndex:int):void {
			dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,evtType,items,startIndex,endIndex));
		}
		
		protected function dispatchPreChangeEvent(evtType:String, items:Vector.<Object>, startIndex:int, endIndex:int):void {
			dispatchEvent(new DataChangeEvent(DataChangeEvent.PRE_DATA_CHANGE, evtType, items, startIndex, endIndex));
		}
	}

}