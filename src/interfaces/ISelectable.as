package interfaces
{
	
	/**
	 * ...
	 * @author Bartosz Woszczyński
	 */
	public interface ISelectable 
	{
		function select(withAnim:Boolean = false):void
		function unselect():void
		function setStartGlowValues():void
	}
	
}